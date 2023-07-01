@echo on

echo Creating plop files...
mkdir "plopTemplates"

echo plopfile.js
(
echo module.exports = function ^(plop^) ^{ 
echo    plop.setGenerator^('js-file', ^{ 
echo      description: 'Generate a JavaScript file', 
echo      prompts: ^[ 
echo        ^{ 
echo          type: 'input', 
echo          name: 'name', 
echo          message: 'Enter the file name ^(without the .js extension^):', 
echo        ^}, 
echo        ^{ 
echo          type: 'input', 
echo          name: 'directory', 
echo          message: 'Enter the Directory destination after src', 
echo        ^} 
echo      ^], 
echo      actions: ^[ 
echo        ^{ 
echo          type: 'add', 
echo          path: 'src/^{^{directory^}^}/^{{name^}^}.js', 
echo          templateFile: 'plopTemplates/js-file-template.hbs', 
echo        ^}, 
echo      ^], 
echo    ^}^); 
echo  ^};
) > "plopfile.js"

echo plopTemplates/js-file-template.hbs

(
echo import React from "react;" 
echo import ^{ View, StyleSheet, Text ^} from 'react-native;' 
echo.
echo const CHANGE = ^(^) =^> {
echo     return ( 
echo         ^<View^> 
echo             ^<Text^>This is the new screen^</Text^> 
echo         ^</View^> 
echo     ^);
echo ^}; 
echo.
echo const styles = StyleSheet.create^(^{ 
echo ^}^); 
echo.
echo export default CHANGE; 
) > "plopTemplates/js-file-template.hbs"
