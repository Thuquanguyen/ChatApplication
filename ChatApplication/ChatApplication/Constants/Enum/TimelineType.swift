//
//  TimelineType.swift
//  TetViet
//
//  Created by ANHTT-D1 on 1/8/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation

enum TimelineType: String {
    case culture = "culture"
    case article = "article"
    case notice = "notice"
    case image = "photo_contest"
    case bookmark_story = "bookmark_story"
    case bookmark_culture = "bookmark_culture"
    case bookmark_article = "bookmark_article"
    case bookmark_emergency = "bookmark_emergency"
    case bookmark_information = "bookmark_information"
    case bookmark_opinion = "bookmark_opinion"
    case notice_culture = "notice_culture"
    case notice_article = "notice_article"
    case notice_chapter = "notice_chapter"
    case lucky_pig = "lucky_pig"
    case bookmark_hotdeal = "bookmark_hotdeal"
    case bookmark_directive_text = "bookmark_directive_text"
    var value: String { return rawValue }
}
