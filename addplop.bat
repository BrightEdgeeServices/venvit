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
echo        ^} ,
echo        ^{
echo           type: 'input',
echo           name: 'fileType',
echo           message: 'Type of file? ^(api/js/context^):',
echo         },
echo      ^], 
echo      actions: ^[ 
echo        ^{ 
echo          type: 'add', 
echo          path: 'src/^{^{directory^}^}/^{{name^}^}.js', 
echo          templateFile: 'plopTemplates/^{^{fileType^}^}-file-template.hbs', 
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

echo plopTemplates/api-file-template.hbs

(
echo import axios from "axios";
echo. 
echo export default axios.create^(^{
echo    baseURL: '',
echo    headers: ^{
echo        Authorization: 'Bearer '
echo    ^}
echo ^}^);
) > "plopTemplates/api-file-template.hbs"

echo plopTemplates/context-file-template.hbs

(
echo import React from "react";
echo.
echo const CHANGEContext = React.createContext^(^);
echo.
echo export const CHANGEProvider = ^(^{ children ^}^) =^> ^{
echo     return ^<CHANGEContext.Provider^>
echo         ^{children^}
echo     ^</CHANGEContext.Provider^>
echo ^};
echo.
echo export default CHANGEContext;
) > "plopTemplates/context-file-template.hbs"
