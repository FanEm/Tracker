// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L {
  public enum Alert {
    /// Отменить
    public static let cancel = L.tr("Localizable", "alert.cancel", fallback: "Отменить")
    /// Удалить
    public static let delete = L.tr("Localizable", "alert.delete", fallback: "Удалить")
    /// Localizable.strings
    ///   Tracker
    public static let ok = L.tr("Localizable", "alert.ok", fallback: "ОК")
  }
  public enum Category {
    /// Закрепленные
    public static let pinned = L.tr("Localizable", "category.pinned", fallback: "Закрепленные")
    /// Привычки и события можно
    /// объединить по смыслу
    public static let placeholder = L.tr("Localizable", "category.placeholder", fallback: "Привычки и события можно\nобъединить по смыслу")
    /// Категория
    public static let title = L.tr("Localizable", "category.title", fallback: "Категория")
    public enum Alert {
      public enum Delete {
        /// Все трекеры из этой категории будут удалены
        public static let subtitle = L.tr("Localizable", "category.alert.delete.subtitle", fallback: "Все трекеры из этой категории будут удалены")
        /// Эта категория точно не нужна?
        public static let title = L.tr("Localizable", "category.alert.delete.title", fallback: "Эта категория точно не нужна?")
      }
    }
    public enum Button {
      /// Добавить категорию
      public static let add = L.tr("Localizable", "category.button.add", fallback: "Добавить категорию")
    }
  }
  public enum ContextMenu {
    /// Удалить
    public static let delete = L.tr("Localizable", "contextMenu.delete", fallback: "Удалить")
    /// Редактировать
    public static let edit = L.tr("Localizable", "contextMenu.edit", fallback: "Редактировать")
    /// Закрепить
    public static let pin = L.tr("Localizable", "contextMenu.pin", fallback: "Закрепить")
    /// Открепить
    public static let unpin = L.tr("Localizable", "contextMenu.unpin", fallback: "Открепить")
  }
  public enum CreateTracker {
    /// Нерегулярное событие
    public static let event = L.tr("Localizable", "createTracker.event", fallback: "Нерегулярное событие")
    /// Привычка
    public static let habit = L.tr("Localizable", "createTracker.habit", fallback: "Привычка")
    /// Создание трекера
    public static let title = L.tr("Localizable", "createTracker.title", fallback: "Создание трекера")
  }
  public enum Filters {
    /// Все трекеры
    public static let all = L.tr("Localizable", "filters.all", fallback: "Все трекеры")
    /// Завершенные
    public static let completed = L.tr("Localizable", "filters.completed", fallback: "Завершенные")
    /// Не завершенные
    public static let incompleted = L.tr("Localizable", "filters.incompleted", fallback: "Не завершенные")
    /// Фильтры
    public static let title = L.tr("Localizable", "filters.title", fallback: "Фильтры")
    /// Трекеры на сегодня
    public static let today = L.tr("Localizable", "filters.today", fallback: "Трекеры на сегодня")
  }
  public enum NewCategory {
    public enum Alert {
      /// Категория с таким именем уже существует
      public static let subtitle = L.tr("Localizable", "newCategory.alert.subtitle", fallback: "Категория с таким именем уже существует")
      /// Невозможно создать категорию
      public static let title = L.tr("Localizable", "newCategory.alert.title", fallback: "Невозможно создать категорию")
    }
    public enum Button {
      /// Готово
      public static let done = L.tr("Localizable", "newCategory.button.done", fallback: "Готово")
    }
    public enum Create {
      /// Новая категория
      public static let title = L.tr("Localizable", "newCategory.create.title", fallback: "Новая категория")
    }
    public enum Edit {
      /// Редактирование категории
      public static let title = L.tr("Localizable", "newCategory.edit.title", fallback: "Редактирование категории")
    }
    public enum TextField {
      /// Введите название категории
      public static let placeholder = L.tr("Localizable", "newCategory.textField.placeholder", fallback: "Введите название категории")
    }
  }
  public enum NewTracker {
    /// Цвет
    public static let color = L.tr("Localizable", "newTracker.color", fallback: "Цвет")
    /// Emoji
    public static let emoji = L.tr("Localizable", "newTracker.emoji", fallback: "Emoji")
    public enum Button {
      /// Отменить
      public static let cancel = L.tr("Localizable", "newTracker.button.cancel", fallback: "Отменить")
      /// Создать
      public static let create = L.tr("Localizable", "newTracker.button.create", fallback: "Создать")
    }
    public enum Event {
      /// Новое нерегулярное событие
      public static let create = L.tr("Localizable", "newTracker.event.create", fallback: "Новое нерегулярное событие")
      /// Редактирование нерегулярного события
      public static let edit = L.tr("Localizable", "newTracker.event.edit", fallback: "Редактирование нерегулярного события")
    }
    public enum Habit {
      /// Новая привычка
      public static let create = L.tr("Localizable", "newTracker.habit.create", fallback: "Новая привычка")
      /// Редактирование привычки
      public static let edit = L.tr("Localizable", "newTracker.habit.edit", fallback: "Редактирование привычки")
    }
    public enum TextField {
      /// Plural format key: "%#@VARIABLE@"
      public static func charLimit(_ p1: Int) -> String {
        return L.tr("Localizable", "newTracker.textField.charLimit", p1, fallback: "Plural format key: \"%#@VARIABLE@\"")
      }
      /// Введите название трекера
      public static let placeholder = L.tr("Localizable", "newTracker.textField.placeholder", fallback: "Введите название трекера")
    }
  }
  public enum Onboarding {
    /// Вот это технологии!
    public static let button = L.tr("Localizable", "onboarding.button", fallback: "Вот это технологии!")
    /// Отслеживайте только то, что хотите
    public static let page1 = L.tr("Localizable", "onboarding.page1", fallback: "Отслеживайте только то, что хотите")
    /// Даже если это не литры воды и йога
    public static let page2 = L.tr("Localizable", "onboarding.page2", fallback: "Даже если это не литры воды и йога")
  }
  public enum Schedule {
    /// Расписание
    public static let title = L.tr("Localizable", "schedule.title", fallback: "Расписание")
    public enum Button {
      /// Готово
      public static let done = L.tr("Localizable", "schedule.button.done", fallback: "Готово")
    }
  }
  public enum Statistics {
    /// Среднее значение
    public static let average = L.tr("Localizable", "statistics.average", fallback: "Среднее значение")
    /// Лучший период
    public static let bestPeriod = L.tr("Localizable", "statistics.bestPeriod", fallback: "Лучший период")
    /// Трекеров завершено
    public static let completed = L.tr("Localizable", "statistics.completed", fallback: "Трекеров завершено")
    /// Идеальные дни
    public static let perfectDays = L.tr("Localizable", "statistics.perfectDays", fallback: "Идеальные дни")
    /// Анализировать пока нечего
    public static let placeholder = L.tr("Localizable", "statistics.placeholder", fallback: "Анализировать пока нечего")
    /// Статистика
    public static let title = L.tr("Localizable", "statistics.title", fallback: "Статистика")
  }
  public enum Trackers {
    /// Что будем отслеживать?
    public static let placeholder = L.tr("Localizable", "trackers.placeholder", fallback: "Что будем отслеживать?")
    /// Трекеры
    public static let title = L.tr("Localizable", "trackers.title", fallback: "Трекеры")
    public enum Alert {
      public enum Delete {
        /// Уверены, что хотите удалить трекер?
        public static let title = L.tr("Localizable", "trackers.alert.delete.title", fallback: "Уверены, что хотите удалить трекер?")
      }
    }
    public enum Search {
      /// Ничего не найдено
      public static let placeholder = L.tr("Localizable", "trackers.search.placeholder", fallback: "Ничего не найдено")
    }
    public enum SearchBar {
      /// Поиск
      public static let placeholder = L.tr("Localizable", "trackers.searchBar.placeholder", fallback: "Поиск")
    }
    public enum Tracker {
      /// Plural format key: "%#@VARIABLE@"
      public static func days(_ p1: Int) -> String {
        return L.tr("Localizable", "trackers.tracker.days", p1, fallback: "Plural format key: \"%#@VARIABLE@\"")
      }
    }
  }
  public enum WeekDay {
    /// Каждый день
    public static let everyDay = L.tr("Localizable", "weekDay.everyDay", fallback: "Каждый день")
    /// Пт
    public static let fr = L.tr("Localizable", "weekDay.fr", fallback: "Пт")
    /// Пятница
    public static let friday = L.tr("Localizable", "weekDay.friday", fallback: "Пятница")
    /// Пн
    public static let mo = L.tr("Localizable", "weekDay.mo", fallback: "Пн")
    /// Понедельник
    public static let monday = L.tr("Localizable", "weekDay.monday", fallback: "Понедельник")
    /// Сб
    public static let sa = L.tr("Localizable", "weekDay.sa", fallback: "Сб")
    /// Суббота
    public static let saturday = L.tr("Localizable", "weekDay.saturday", fallback: "Суббота")
    /// Вс
    public static let su = L.tr("Localizable", "weekDay.su", fallback: "Вс")
    /// Воскресенье
    public static let sunday = L.tr("Localizable", "weekDay.sunday", fallback: "Воскресенье")
    /// Чт
    public static let th = L.tr("Localizable", "weekDay.th", fallback: "Чт")
    /// Четверг
    public static let thursday = L.tr("Localizable", "weekDay.thursday", fallback: "Четверг")
    /// Вт
    public static let tu = L.tr("Localizable", "weekDay.tu", fallback: "Вт")
    /// Вторник
    public static let tuesday = L.tr("Localizable", "weekDay.tuesday", fallback: "Вторник")
    /// Ср
    public static let we = L.tr("Localizable", "weekDay.we", fallback: "Ср")
    /// Среда
    public static let wednesday = L.tr("Localizable", "weekDay.wednesday", fallback: "Среда")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
