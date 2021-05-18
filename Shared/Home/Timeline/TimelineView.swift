//
//  TimelineView.swift
//  saucialApp
//
//  Created by kawayuta on 5/6/21.
//

import SwiftUI
import PartialSheet
import SwiftUIX
import SwiftUIRefresh

struct TimelineView: View {
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @EnvironmentObject var viewModel: TimelineViewModel
//    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    @State var postReviewVisible: Bool = false
    @State var mypageVisible: Bool = false
    @State var postMenuVisible: Bool = false
    @State var activity_id: Int = 0
    
    @State private var isPullShowing = false
    
    let mainColor = Color.Neumorphic.main
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                RefreshControl(coordinateSpace: .named("RefreshControl")) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        viewModel.fetchTimeline()
                    }
                }
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, spacing: 0) {
                    ForEach(viewModel.activities.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 0) {

                            timelineActivityHeader(user: $viewModel.activities[index].user,
                                                   activity: $viewModel.activities[index],
                                                   postMenuVisible: $postMenuVisible, activity_id: $activity_id)
                            timelineActivityBodyView(body: $viewModel.activities[index].body)
                            if let images = $viewModel.activities[index].images {
                                timelineActivityImageView(images: images)
                                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            }
//
                            timelineActivityFooter(activity: $viewModel.activities[index], sauna: $viewModel.activities[index].sauna)

                            LikeButtonView(viewModel: .init(activity_id: String(viewModel.activities[index].id)))
                                .buttonStyle(PlainButtonStyle())

                        }.cornerRadius(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                        .border(Color(hex: "dedede"), width: 1, cornerRadius: 10)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .partialSheet(isPresented: $postMenuVisible) {
                    menuView(activity_id: $activity_id, postMenuVisible: $postMenuVisible)
                        .onDisappear() {
                            viewModel.fetchTimeline()
                        }
                }
            }.coordinateSpace(name: "RefreshControl")
            postReviewButton
        }
        .addPartialSheet(style: PartialSheetStyle(background: .solid(mainColor),
                                                              handlerBarColor: Color(UIColor.systemGray2),
                                                              enableCover: true,
                                                              coverColor: Color.black.opacity(0.4),
                                                              blurEffectStyle: nil,
                                                              cornerRadius: 15, minTopDistance: 0))
    }
    
    
    
    var postReviewButton: some View {
        
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            postReviewVisible = true
        }, label: {
            VStack {
                Image(systemName: "highlighter")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top:2, leading: 0, bottom: 0, trailing: 2))
                Text("サ活記録")
                    .font(.headline)
                    .foregroundColor(Color.white)
            }
        })
        .partialSheet(isPresented: $postReviewVisible) {
            postActivityReviewView(mapViewModel: mapViewModel, isPresent: $postReviewVisible, myPageVisible: $mypageVisible)
                .onDisappear() {
                    viewModel.fetchTimeline()
//                    userViewModel.fetchUser()
                }
        }
        .frame(width: 80, height: 80)
        .background(RoundedRectangle(cornerRadius: 40).fill(Color.blue).softOuterShadow())
        .padding(EdgeInsets(top:0, leading: 0, bottom: 15, trailing: 15))
    }
    
    
    
    
}


struct timelineActivityHeader: View {
    
    @Binding var user: TimelineUser
    @Binding var activity: TimelineActivity
    @Binding var postMenuVisible: Bool
    @Binding var activity_id: Int
    let current_user_id = UserDefaults.standard.integer(forKey: "current_id")
    let mainColor = Color.Neumorphic.main
    
    init(user: Binding<TimelineUser>, activity: Binding<TimelineActivity>, postMenuVisible: Binding<Bool>, activity_id: Binding<Int>) {
        _activity_id = activity_id
        _user = user
        _activity = activity
        _postMenuVisible = postMenuVisible
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                if let avatar = user.avatar {
                    Group {
                        if let image_url = avatar.url {
                            URLImageView("\(API.init().imageUrl)\(String(describing: image_url))")
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .border(Color.white, width: 0, cornerRadius: 15)
                                .cornerRadius(15)
                        } else {
                            Image(uiImage: Bundle.main.icon ?? UIImage())
                                .resizable()
                                .frame(width: 30, height: 30)
                                .border(Color.white, width: 0, cornerRadius: 15)
                                .cornerRadius(15)
                        }
                        
                    }
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
                    
                }
                
                Group {
                    if let name = user.name {
                        Text("\(name)").font(.headline, weight: .bold)
                    } else {
                        Text("名無しサウナー") .font(.headline, weight: .bold)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 15))
                
                if activity.user.id == current_user_id {
                    HStack(alignment: .center) {
                        Spacer()
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            activity_id = activity.id
                            postMenuVisible = true
                        }) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                        }
                        .foregroundColor(.gray)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 15))
                }
            }
            
            
            Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                    .padding(EdgeInsets(top:  0, leading: 0, bottom: 0, trailing: 0))
        }.background(mainColor)
    }
}


struct menuView: View {
    @EnvironmentObject var viewModel: TimelineViewModel
    @Binding var activity_id: Int
    @Binding var postMenuVisible: Bool
    
    init(activity_id: Binding<Int>, postMenuVisible: Binding<Bool>) {
        _activity_id = activity_id
        _postMenuVisible = postMenuVisible
    }
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.deleteTimelineActivity(activity_id: activity_id, completion: { deleteCompletion in
                    if deleteCompletion == true {
                        let activity_index = self.viewModel.activities.indices.filter {self.viewModel.activities[$0].id == activity_id}.first
                        if let index = activity_index {
                            viewModel.activities.remove(at: index)
                        }
                        postMenuVisible = false
                    }
                })
            }) {
                HStack {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    Text("この投稿を削除する")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(15)
                }
            }
            .foregroundColor(.gray)
        }
    }
}

struct timelineActivityFooter: View {
    
    @Binding var activity: TimelineActivity
    @Binding var sauna: TimelineSauna
    let mainColor = Color.Neumorphic.main
    
    init(activity: Binding<TimelineActivity>, sauna: Binding<TimelineSauna>) {
        _activity = activity
        _sauna = sauna
    }
    
    var body: some View {
        HStack(alignment: .top) {
            URLImageView("\(API.init().imageUrl)\(sauna.image.url)")
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fill)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(sauna.name_ja)
                        .font(.headline, weight: .bold)
                        .frame(alignment: .top)
                        .foregroundColor(.white)
                    
                    Text(sauna.address)
                        .font(.subheadline, weight: .regular)
                        .frame(alignment: .top)
                        .foregroundColor(.white)
                }
                Spacer()
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .trailing) {
                        Text("サウナ: ")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                        Text("水風呂: ")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                        Text("休憩: ")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                    }
                    .frame(width: 44)
                    
                    VStack(alignment: .trailing) {
                        Text("\(activity.sauna_time)分 - \(activity.sauna_count)回")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                        Text("\(activity.mizuburo_time)分 - \(activity.mizuburo_count)回")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                        Text("\(activity.rest_time)分 - \(activity.rest_count)回")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                    }
                }
            }.frame(height: 80)
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 15))
        }
        .background(RoundedRectangle(cornerRadius: 0).fill(Color.blue))
    }
}



struct timelineActivityBodyView: View {
    
    @Binding var activityBody: String
    let mainColor = Color.Neumorphic.main
    
    init(body: Binding<String>) {
        _activityBody = body
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(activityBody)
                .lineLimit(6)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 0))
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
}

struct timelineActivityImageView: View {
    
    @Binding var activityImages: [Images]?
    
    init(images: Binding<[Images]?>) {
        _activityImages = images
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if activityImages!.count != 0 {
                Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
            HStack {
                if activityImages!.count == 1 {
                    LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, spacing: 0) {
                        ForEach(activityImages!.indices, id: \.self) { index in                        URLImageView("\(API.init().imageUrl)\(activityImages![index].url)")
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 230)
                            .clipped()
                            .border(Color.white, width: 0, cornerRadius: 10)
                            .cornerRadius(10)
                        }
                    }
                    .frame(height: 230)
                    .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                }
                
                
                if activityImages!.count == 2 {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 0) {
                        ForEach(activityImages!.indices, id: \.self) { index in                        URLImageView("\(API.init().imageUrl)\(activityImages![index].url)")
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 230)
                            .clipped()
                            .border(Color.white, width: 0, cornerRadius: 10)
                            .cornerRadius(10)
                        }
                    }
                    .frame(height: 230)
                    .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                }
                
                if activityImages!.count == 3 {
                    VStack {
                        LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, spacing: 0) {
                            ForEach([activityImages?.first].indices, id: \.self) { index in                        URLImageView("\(API.init().imageUrl)\(activityImages![index].url)")
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 150)
                                .clipped()
                                .border(Color.white, width: 0, cornerRadius: 10)
                                .cornerRadius(10)
                            }
                        }
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 0) {
                            ForEach(activityImages![1...2].indices, id: \.self) { index in                        URLImageView("\(API.init().imageUrl)\(activityImages![index].url)")
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 80)
                                .clipped()
                                .border(Color.white, width: 0, cornerRadius: 10)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .frame(height: 230)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                }
            
            }
        }
    }

}




struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
