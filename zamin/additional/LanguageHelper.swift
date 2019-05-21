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
    
    static func apiLang() -> String{
        let currentLocale = UserDefaults.getLocale()
        if currentLocale == "uz" {return "oz"}
        else if currentLocale == "kr" {return "uz"}
        
        else { return "oz" }
    }
    
    static func getString(stringId: StringsId) -> String{
        let lang = UserDefaults.getLocale()
        
        if lang == "uz" {
            return StringUZ.getString(id: stringId)
        }
        else if lang == "kr"{
            return StringKR.getString(id: stringId)
        }
        
        
        return ""
    }
    
    static func getArray(arrayId: ArraysId) -> [String]{
        let lang = UserDefaults.getLocale()
        
        if lang == "uz" {
            return ArrayUZ.getArray(id: arrayId)
        }
        else if lang == "kr"{
            return ArrayKR.getArray(id: arrayId)
        }
        
        
        return [""]
    }
    
    enum ArraysId{
        
        case months
        case week_days
        
    }
    
    enum StringsId{
        
        case menu_news_feed
        case menu_top
        case menu_favourites
        case menu_media
        case text_news
        case text_choose_language
        case text_back
        case text_submit
        case message_no_connection
        case title_audio_news
        case messege_audio
        case title_favourites
        case message_favourites
        case title_foto
        case message_foto
        case text_last_news
        case text_main_news
        case text_audio_news2
        case text_all
        case text_video_news
        case title_video_news
        case message_video
        case tab_audio
        case tab_video
        case tab_gallery
        case toolbar_profile
        case text_notification
        case text_categories
        case text_select_language
        case language
        case text_results
        case title_select_categories
        case today
        case text_share
        case text_no_connection
        case check_the_connection
        case text_no_favourites
        case text_no_audio
        case text_registration
        case text_no_item
        case text_refresh
        case text_reset_alert_title
        case text_reset_alert_messege
        case text_yes
        case text_login_alert_disabled
    }
    
    
  
    

    
    
    
}





extension LanguageHelper{
    
    //MARK: - Strings
    struct StringUZ {
        static func getString(id: StringsId) -> String{
            switch id {
                
            case StringsId.menu_news_feed: return "Lenta"
            case StringsId.menu_top: return "Top"
            case StringsId.menu_favourites: return "Tanlanganlar"
            case StringsId.menu_media: return "Media"
            case StringsId.text_news: return "Qidirish"
            case StringsId.text_choose_language: return "Tilni tanlang"
            case StringsId.text_back: return "Ortga"
            case StringsId.text_submit: return "Tanlash"
            case StringsId.message_no_connection: return "Internetga ulanishning iloji yo\'q"
            case StringsId.title_audio_news: return "Audio xabarlar"
            case StringsId.messege_audio: return "O\'zbekistonda va jahonda bo\'layotgan voqealarning audio xabarlari"
            case StringsId.title_favourites: return "Sizning xabarlaringiz"
            case StringsId.message_favourites: return "Zamin siz uchun muhim xabarlarni saqlab turadi"
            case StringsId.title_foto: return "Foto kolleksiya"
            case StringsId.message_foto: return "O\'zbekistonda va jahonda bo\'layotgan voqealarning foto jamlanmasi"
            case StringsId.text_last_news: return "So\'nggi yangiliklar"
            case StringsId.text_main_news: return "Asosiy yangiliklar"
            case StringsId.text_audio_news2: return "Audio yangiliklar"
            case StringsId.text_all: return "Barchasi"
            case StringsId.text_video_news: return "Video yangiliklar"
            case StringsId.title_video_news: return "Video xabarlar"
            case StringsId.message_video: return "Zamin studiyasining dolzarb mavzudagi intervyulari"
            case StringsId.tab_audio: return "Audio"
            case StringsId.tab_video: return "Video"
            case StringsId.tab_gallery: return "Galereya"
            case StringsId.toolbar_profile: return "Profil"
            case StringsId.text_notification: return "Bildirishlar"
            case StringsId.text_categories: return "Ruknlar"
            case StringsId.text_select_language: return "Tilni tanlash"
            case StringsId.language: return "O\'zbek"
            case StringsId.text_results: return "qidiruv natijalari"
            case StringsId.title_select_categories: return "Kategoriyalar"
            case StringsId.today: return "Bugun"
            case StringsId.text_share: return "Yangilikni ulashish"
            case StringsId.text_no_connection: return "Tilni o\'zgartirish uchun internetga ulaning"
            case StringsId.check_the_connection: return "Internetga ulanganingizni tekshirib ko\'ring"
            case StringsId.text_no_favourites: return "Saqlangan xabarlar topilmadi"
            case StringsId.text_no_audio: return "Audio xabarlar topilmadi"
            case StringsId.text_registration: return "Ro\'yxatdan o\'tish"
            case StringsId.text_no_item: return "Yangiliklar topilmadi"
            case StringsId.text_refresh: return "Takrorlash"
            case .text_reset_alert_title: return "Barcha o'zgarishlarni bekor qilmoqchimisiz"
            case .text_reset_alert_messege: return "ortga qaytishning iloji bo'lmaydi"
            case .text_yes: return "Ha"
            case .text_login_alert_disabled: return "Ro'yxatdan o'tishning iloji yo'q"
            }
            
        }
        
    }
    
    struct StringKR {
        static func getString(id: StringsId) -> String{
            switch id {
                
                
            case StringsId.menu_news_feed: return "Лента"
            case StringsId.menu_top: return "Топ"
            case StringsId.menu_favourites: return "Танланганлар"
            case StringsId.menu_media: return "Медиа"
            case StringsId.text_news: return "Қидириш"
            case StringsId.text_choose_language: return "Тилни танланг"
            case StringsId.text_back: return "Ортга"
            case StringsId.text_submit: return "Танлаш"
            case StringsId.message_no_connection: return "Интернетга уланишнинг иложи йўқ"
            case StringsId.title_audio_news: return "Аудио хабарлар"
            case StringsId.messege_audio: return "Ўзбекистонда ва жаҳонда бўлаётган воқеаларнинг аудио хабарлари"
            case StringsId.title_favourites: return "Сизнинг хабарларингиз"
            case StringsId.message_favourites: return "Замин сиз учун муҳим хабарларни сақлаб туради"
            case StringsId.title_foto: return "Фото коллексия"
            case StringsId.message_foto: return "Ўзбекистонда ва жаҳонда бўлаётган воқеаларнинг фото жамланмаси"
            case StringsId.text_last_news: return "Сўнгги янгиликлар"
            case StringsId.text_main_news: return "Асосий янгиликлар"
            case StringsId.text_audio_news2: return "Аудио янгиликлар"
            case StringsId.text_all: return "Барчаси"
            case StringsId.text_video_news: return "Видео янгиликлар"
            case StringsId.title_video_news: return "Видео хабарлар"
            case StringsId.message_video: return "Замин студиясининг долзарб мавзудаги интервюлари"
            case StringsId.tab_audio: return "Аудио"
            case StringsId.tab_video: return "Видео"
            case StringsId.tab_gallery: return "Галерея"
            case StringsId.toolbar_profile: return "Профил"
            case StringsId.text_notification: return "Билдиришлар"
            case StringsId.text_categories: return "Рукнлар"
            case StringsId.text_select_language: return "Тилни танлаш"
            case StringsId.language: return "Ўзбек"
            case StringsId.text_results: return "қидирув натижалари"
            case StringsId.title_select_categories: return "Категориялар"
            case StringsId.today: return "Бугун"
            case StringsId.text_no_connection: return "Tilni o\'zgartirish uchun internetga ulaning"
            case StringsId.check_the_connection: return "Internetga ulanganingizni tekshirib ko\'ring"
            case StringsId.text_share: return "Янгиликларни улашиш"
            case StringsId.text_no_favourites: return "Сақланган хабарлар топилмади"
            case StringsId.text_no_audio: return "Аудио хабарлар топилмади"
            case StringsId.text_registration: return "Рўйхатдан ўтиш"
            case StringsId.text_no_item: return "Янгиликлар топилмади"
            case StringsId.text_refresh: return "Такрорлаш"
            case .text_reset_alert_title: return "Барча ўзгаришларни бекор қилмоқчимисиз"
            case .text_reset_alert_messege: return "ортга қайтишнинг иложи бўлмайди"
            case .text_yes: return "Ҳа"
            case .text_login_alert_disabled: return "Рўйхатдан ўтишнинг иложи йўқ"
            }
            
        }
    }
    
    
    
}








extension LanguageHelper{
    //MARK: - Arrays
    struct ArrayUZ {
        static func getArray(id: ArraysId) -> [String]{
            switch id {
            case .months: return
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
                
            case .week_days: return
                [""]
            }
        }
    }
    
    struct ArrayKR {
        static func getArray(id: ArraysId) -> [String]{
            switch id {
            case .months: return
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
                
            case .week_days: return
                [""]
            }
        }
    }
    
}
