# Easy JSON Locale for Godot

**Godot plugin to import hierarchical JSON files as `.translation` resources for localization.**

This plugin allows you to manage your game translations using JSON files, with support for nested groups and multiple locales. It automatically converts them into Godot `.translation` resources using the import system.

---

## ✨ Features

- ✅ Import `.json` translation files directly into Godot.
- ✅ Support for nested/grouped keys (hierarchical structure).
- ✅ Multiple locales in a single file.
- ✅ Automatic generation of `.translation` files per locale.
- ✅ Works seamlessly with Godot's localization system.

---

## 📁 JSON Format Example

Here's an example of the JSON structure:

```json
{
  "Common":
  {
    "Yes":
    {
      "en": "Yes",
      "es": "Sí"
    },
    "No":
    {
      "en": "No",
      "es": "No"
    }
  },
  "SceneTitle":
  {
    "NavBtn_Play":
    {
      "en": "Play",
      "es": "Jugar"
    }
  }
}
```

This will generate:
- your_file.en.translation
- your_file.es.translation

With keys like:
- Common_Yes, Common_No
- SceneTitle_NavBtn_Play

## 🚀 Installation
Copy the plugin files into your Godot project's addons/ directory.
Activate the plugin in Project > Project Settings > Plugins.
Add your .json translation files anywhere in the project.
Godot will automatically generate .translation files for each language.

## 🛠️ Usage Tips
Use unique keys to avoid conflicts across different groups.
If you update your JSON file, Godot will re-import the translations.
You can organize keys using nested dictionaries for better readability.

## 📄 License
MIT License.
Feel free to use, modify, and share this plugin!

## 🙌 Credits
Created by Alberto with ❤️ for clean and scalable localization in Godot.
