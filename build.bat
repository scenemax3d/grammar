del *.java
del *.tokens

"C:\Program Files\Java\jdk1.8.0_45\jre\bin\java.exe" -Xmx500M -cp antlr-4.5.3-complete.jar org.antlr.v4.Tool -no-listener -visitor SceneMax.g4

SET CLASSPATH=.;antlr-4.5.3-complete.jar;%CLASSPATH%
javac -d build SceneMax*.java
del *.java
del *.tokens
cd build
rmdir com
jar cvf scenemax_parser.jar *
xcopy scenemax_parser.jar ..\..\libs
xcopy scenemax_parser.jar ..\..\scenemax_win_projector\libs

pause
