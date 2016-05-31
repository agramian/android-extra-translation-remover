# android-extra-translation-remover

Script to remove extra translations from an Android project.  It bases removal off of the default strings.xml resource file **[path]/res/values/strings.xml**.

### Usage

Make sure you have **ruby** on your system and run the following command.
`ruby android-extra-translation-remover.rb -r [android-project-resource-file-dir]` 

The only argument is the path to your project's Android resource file directory (where the **values** folders are which contain the localized **strings.xml** files).

ex: `ruby android-extra-translation-remover.rb -r /Users/agramian/Documents/Android-Project/src/main/res`

If no Android resource file directory is specified as an argument, the script will assume it is being run from inside the resource directory.
