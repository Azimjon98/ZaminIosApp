//
//  LanguageHelper.swift
//  zamin
//
//  Created by Azimjon Nu'monov on 4/27/19.
//  Copyright © 2019 Azimjon Nu'monov. All rights reserved.
//

import Foundation

final class LanguageHelper {
    init() {}
    
    static let shared = LanguageHelper()
    
    func getLang(){
        UserDefaults.standard.string(forKey: Constants.KEY_LANG)
    }
    
    let monthsUZ: [String] =
        [
            "Yanvar",
            "Fevral",
            "Mart",
            "Aprel",
            "May",
            "Iyun",
            "Iyul",
            "Avgust",
            "Sentabr",
            "Oktabr",
            "Noyabr",
            "Dekabr"
        ]
    let monthsKR: [String] =
        [
            "Январ",
            "Феврал",
            "Март",
            "Апрел",
            "Май",
            "Июн",
            "Июл",
            "Август",
            "Сентабр",
            "Октабр",
            "Ноябр",
            "Декабр"
    ]
    enum ADw{
        case a
    }

    enum UZStrings : String{

        
        case menu_news_feed = "Lenta"
        case menu_top = "Top"
        case menu_favourites = "Tanlanganlar"
        case menu_media = "Media"
        case text_news = "Yangiliklar"
        case text_choose_language = "Tilni tanlang"
        case text_back = "Ortga"
        case text_submit = "Tanlash"
        case message_no_connection = "Internetga ulanishning iloji yo\'q"
        case title_audio_news = "Audio xabarlar"
        case messege_audio = "O\'zbekistonda va jahonda bo\'layotgan voqealarning audio xabarlari"
        case title_favourites = "Sizning xabarlaringiz"
        case message_favourites = "Zamin siz uchun muhim xabarlarni saqlab turadi"
        case title_foto = "Foto kolleksiya"
        case message_foto = "O\'zbekistonda va jahonda bo\'layotgan voqealarning foto jamlanmasi"
        case text_last_news = "So\'nggi yangiliklar"
        case text_main_news = "Asosiy yangiliklar"
        case text_audio_news2 = "Audio yangiliklar"
        case text_all = "Barchasi"
        case text_video_news = "Video yangiliklar"
        case title_video_news = "Video xabarlar"
        case message_video = "Zamin studiyasining dolzarb mavzudagi intervyulari"
        case tab_audio = "Audio"
        case tab_video = "Video"
        case tab_gallery = "Galereya"
        case toolbar_profile = "Profil"
        case text_notification = "Bildirishlar"
        case text_categories = "Ruknlar"
        case text_select_language = "Tilni tanlash"
        case language = "O\'zbek"
        case text_results = "qidiruv natijalari"
        case title_select_categories = "Kategoriyalarni tanlang"
        case today = "Bugun"
        case text_share = "Yangilikni ulashish"
        case text_no_connection = "Tilni o\'zgartirish uchun internetga ulaning"
        case check_the_connection = "Internetga ulanganingizni tekshirib ko\'ring"
        case text_no_favourites = "Saqlangan xabarlar topilmadi"
        case text_no_audio = "Audio xabarlar topilmadi"
        case text_registration = "Ro\'yxatdan o\'tish"
        
        
        func toString() -> String {
            return self.rawValue
        }
    }
    
    enum KRStrings : String {
        case menu_news_feed = "Лента"
        case menu_top = "Топ"
        case menu_favourites = "Танланганлар"
        case menu_media = "Медиа"
        case text_news = "Янгиликлар"
        case text_choose_language = "Тилни танланг"
        case text_back = "Ортга"
        case text_submit = "Танлаш"
        case message_no_connection = "Интернетга уланишнинг иложи йўқ"
        case title_audio_news = "Аудио хабарлар"
        case messege_audio = "Ўзбекистонда ва жаҳонда бўлаётган воқеаларнинг аудио хабарлари"
        case title_favourites = "Сизнинг хабарларингиз"
        case message_favourites = "Замин сиз учун муҳим хабарларни сақлаб туради"
        case title_foto = "Фото коллексия"
        case message_foto = "Ўзбекистонда ва жаҳонда бўлаётган воқеаларнинг фото жамланмаси"
        case text_last_news = "Сўнгги янгиликлар"
        case text_main_news = "Асосий янгиликлар"
        case text_audio_news2 = "Аудио янгиликлар"
        case text_all = "Барчаси"
        case text_video_news = "Видео янгиликлар"
        case title_video_news = "Видео хабарлар"
        case message_video = "Замин студиясининг долзарб мавзудаги интервюлари"
        case tab_audio = "Аудио"
        case tab_video = "Видео"
        case tab_gallery = "Галерея"
        case toolbar_profile = "Профил"
        case text_notification = "Билдиришлар"
        case text_categories = "Рукнлар"
        case text_select_language = "Тилни танлаш"
        case language = "Ўзбек"
        case text_results = "қидирув натижалари"
        case title_select_categories = "Категорияларни танланг"
        case today = "Бугун"
        case text_no_connection = "Tilni o\'zgartirish uchun internetga ulaning"
        case check_the_connection = "Internetga ulanganingizni tekshirib ko\'ring"
        case text_share = "Янгиликларни улашиш"
        case text_no_favourites = "Сақланган хабарлар топилмади"
        case text_no_audio = "Аудио хабарлар топилмади"
        case text_registration = "Рўйхатдан ўтиш"
        
        func toString() -> String {
            return self.rawValue
        }
    }
    


    
    
    
}
