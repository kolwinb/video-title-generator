#!/bin/bash

bgcolor="black"

csize="1920x1080"
c_width="1920"
c_height="1080"
bgalpha="100"
bsize1="1920x100"
bsize2="1920x200"
bsize3="1920x300"
fbgcolor1="none"
fbgcolor2="none"
fbgcolor3="none"
fcolor1="white"
fcolor2="white"
fcolor3="white"
fontsize1="100"
fontsize2="50"
fontsize3="50"
strokesize1="0"
strokesize2="0"
strokesize3="0"
strokecolor1="none"
strokecolor2="none"
strokecolor3="none"
xposition1="100"
yposition1="100"
xposition2="100"
yposition2="300"
xposition3="100"
yposition3="800"
textwidth1="1800"
textheight1="100"
textwidth2="1800"
textheight2="700"
textwidth3="1800"
textheight3="200"
fontdic1="FreeSan"
fontdic2="FreeSan"
fontdic3="FreeSan"

function convertimg
{
echo "Wait..."
index=1
imgfilname=$(echo $wordpath | awk -F/ '{print $NF}')
trimfname=${imgfilname%.*}
echo $trimfname
while read line
do
word_line=$(echo $line | cut -d',' -f1)
cword_line=$(sed -e 's/\b./\u\0/' <<< $word_line)
gloss_line=$(echo $line | cut -d',' -f2)
cgloss_line=$(sed -e 's/\b./\u\0/' <<< $gloss_line)
sentence_line=$(echo $line | cut -d',' -f3)
csentence_line=$(sed -e 's/\b./\u\0/' <<< $sentence_line)
convert -background $bgcolor -size $csize xc:$bgcolor -alpha set -channel Alpha -evaluate set $bgalpha% \
 \( -size $textwidth1"x"$textheight1 -background $fbgcolor1 -fill $fcolor1 -pointsize $fontsize1  -geometry +$xposition1+$yposition1 -stroke $strokecolor1 -strokewidth $strokesize1 caption:"${cword_line}" \) \
-compose Over -composite \
 \( -size $textwidth2"x"$textheight2 -background $fbgcolor2 -fill $fcolor2 -pointsize $fontsize2  -geometry +$xposition2+$yposition2 -stroke $strokecolor2 -strokewidth $strokesize2 caption:"${cgloss_line}" \) \
-compose Over -composite \
 \( -size $textwidth3"x"$textheight3 -background $fbgcolor3 -fill $fcolor3 -pointsize $fontsize3  -geometry +$xposition3+$yposition3 -stroke $strokecolor3 -strokewidth $strokesize3 caption:"$csentence_line" \) \
-composite  $savepath/$trimfname-$index.png
((index++))
done < $wordpath
init
}

function saveas
{
savepath=$(zenity --file-selection --directory 2>/dev/null)
init
}

function configuration
{
val=$(zenity --forms --title="Program Setting" --text="New Setting" \
   --add-entry="Canvas Width(1920)" \
   --add-entry="Canvas Height(1080)"  2>/dev/null)

if [ $? -eq 1 ];then
c_width="1920"
c_height="1080"
else
c_width=$(echo $val | cut -d'|' -f1)
c_height=$(echo $val | cut -d'|' -f2)
fi
csize=$c_width"x"$c_height
bsize=$b_width"x"$b_height

init
}

function openword
{
wordpath=$(zenity --file-selection --file-filter="*.*" \
   --file-filter="*.txt" \
   --file-filter="*.odc" 2> /dev/null )
echo $wordpath
init
}

function colorpalatte
{
colorvalue=$(zenity --color-selection --show-palette 2> /dev/null)
}

function fontstrokecolor
{
case $1 in
1) colorpalatte "Word";strokecolor1=$colorvalue;echo "word stroke color : " $colorvalue;commonlist 1;;
2) colorpalatte "Gloss";strokecolor2=$colorvalue;echo "gloss stroke color : " $colorvalue;commonlist 2;;
3) colorpalatte "Sentences";strokecolor3=$colorvalue;echo "sentence stroke color : " $colorvalue;commonlist 3;;
*) echo "error";
esac

}

function backcolor
{
colorpalatte "Font(100)"
bgcolor=$colorvalue
echo "background : $colorvalue"
init
}

function fontcolor
{
case $1 in
1) colorpalatte "Word";fcolor1=$colorvalue;echo "word font color : "$colorvalue;commonlist 1;;
2) colorpalatte "Gloss";fcolor2=$colorvalue;echo "gloss font color : "$colorvalue;commonlist 2;;
3) colorpalatte "Sentences";fcolor3=$colorvalue;echo "sentence font color : "$colorvalue;commonlist 3;;
*) echo "error";
esac
commonlist "Color"
}

function bannercolor
{
colorpalatte "Banner"
bcolor=$colorvalue
init
}

#entry for input value
function entervalue
{
entryvalue=$(zenity  --entry --text $1 2>/dev/null)
}

#font size entry
function fontproperty
{
case $1 in
1) entervalue "Word"; fontsize1=$entryvalue;echo "word font size : "$entryvalue;commonlist 1;;
2) entervalue "Gloss"; fontsize2=$entryvalue;echo "gloss font size : "$entryvalue;commonlist 2;;
3) entervalue "Sentences"; fontsize3=$entryvalue;echo "sentence font size : "$entryvalue;commonlist 3;;
*) echo "error";
esac

commonlist "Font"
}

function fontstrokesize
{
case $1 in
1) entervalue "Word";strokesize1=$entryvalue;echo "word stroke width : "$entryvalue;commonlist 1;;
2) entervalue "Gloss";strokesize2=$entryvalue;echo "gloss stroke width : "$entryvalue;commonlist 2;;
3) entervalue "Sentences";strokesize3=$entryvalue;echo "sentence stroke width : "$entryvalue;commonlist 3;;
*) echo "error";
esac
}

function textxposition
{
case $1 in
1) textboxsize $c_width $xposition1 "Textbox_Position_Left_to_Right";xposition1=$txtsize;echo "word x location : "$txtsize;commonlist 1;;
2) textboxsize $c_width $xposition2 "Textbox_Position_Left_to_Right";xposition2=$txtsize;echo "gloss x location : "$txtsize;commonlist 2;;
3) textboxsize $c_width $xposition3 "Textbox_Position_Left_to_Right";xposition3=$txtsize;echo "sentence x location : "$txtsize;commonlist 3;;
*) echo "error";
esac
}

function textboxsize
{
curvalue=$2
txtsize=$(zenity --scale --text "$3" --min-value=0 --max-value=$1 --value=$curvalue --step 1 2>/dev/null)

if [ $? -eq 1 ];then
txtsize=$2
fi

}

function textwidth
{
case $1 in
1) textboxsize $c_width $textwidth1 "Textbox_Width";textwidth1=$txtsize;echo "word text width : "$txtsize;commonlist 1;;
2) textboxsize $c_width $textwidth2 "Textbox_Width";textwidth2=$txtsize;echo "gloss text width : "$txtsize;commonlist 2;;
3) textboxsize $c_width $textwidth3 "Textbox_Width";textwidth3=$txtsize;echo "sentence text width : "$txtsize;commonlist 3;;
*) echo "error";
esac
}

function textheight
{
case $1 in
1) textboxsize $c_height $textheight1 "Textbox_Height";textheight1=$txtsize;echo "word text height : "$txtsize;commonlist 1;;
2) textboxsize $c_height $textheight2 "Textbox_Height";textheight2=$txtsize;echo "gloss text height : "$txtsize;commonlist 2;;
3) textboxsize $c_height $textheight3 "Textbox_Height";textheight3=$txtsize;echo "sentence text height : "$txtsize;commonlist 3;;
*) echo "error";
esac
}

function textyposition
{
case $1 in
1) textboxsize $c_height $yposition1 "Textbox_Position_Top_To_Bottom";yposition1=$txtsize;echo "word y location : "$txtsize;commonlist 1;;
2) textboxsize $c_height $yposition2 "Textbox_Position_Top_To_Bottom";yposition2=$txtsize;echo "gloss y location : "$txtsize;commonlist 2;;
3) textboxsize $c_height $yposition3 "Textbox_Position_Top_To_Bottom";yposition3=$txtsize;echo "sentence y location : "$txtsize;commonlist 3;;
*) echo "error";
esac
}

function textfont
{
case $1 in
1) fontlist;fontdict1=$fonttype;echo "word font type : "$fonttype;commonlist 1;;
2) fontlist;fontdict2=$fonttype;echo "gloss font type : "$fonttype;commonlist 2;;
3) fontlist;fontdict3=$fonttype;echo "sentence font type : "$fonttype;commonlist 3;;
*) echo "error";
esac

}

function fontlist
{

#fontdic=$(zenity --list --title="Font List" --height 500 --multiple  --column="flist" $(fc-list |  cut -d':' -f2))
fonttype=$(fc-list | cut -d':' -f2 | zenity --list --title="Font List" --height 500 --multiple  --column="flist" 2>/dev/null )
if [[ $? -eq 0 ]];then
echo "Font type is not specified"
fi


}

function backtransparency
{
commonalpha
bgalpha=$calpha
init
}

function bannertransparency
{
commonalpha
alphavalue=$calpha
init
}

function commonalpha
{
calpha=$(zenity --scale --text "Transparency" --min-value=0 --max-value=100 --value=50 --step 1 2>/dev/null)
}

function commonlist
{
#echo $1
mode=$(zenity --height 400 --list  --title=$1 --column="mode" "Text X Position" "Text Y Position"  "Textbox Width" "Textbox Height"  "Font Color" "Font Size" "Font List" "Font Stroke Size" "Font Stroke Color" "Update" "Back" 2>/dev/null )
tmode=$(echo $mode | cut -d'|' -f1)
case $tmode in
"Text X Position") textxposition $1;;
"Text Y Position") textyposition $1;;
"Textbox Width") textwidth $1;;
"Textbox Height")textheight $1;;
"Font Color" ) fontcolor $1;;
"Font Size") fontproperty $1;;
"Font List") textfont $1;;
"Font Stroke Size") fontstrokesize $1;;
"Font Stroke Color") fontstrokecolor $1;;
"Update") convertimg;;
"Back")init;;
* ) echo "none";;
esac
init
}

function init
{
mode=$(zenity --height 400 --list  --title="Main Configuration" --column="mode" "Frame Settings" "Open Word List" "Background Color" "Background Transparency" "Word" "Gloss" "Sentences" "Save As" "Update" 2>/dev/null)
tmode=$(echo $mode | cut -d'|' -f1)
case $tmode in
"Frame Settings") configuration;;
"Open Word List") openword ;;
"Background Color") backcolor;;
"Background Transparency") backtransparency;;
"Word") commonlist 1;;
"Gloss") commonlist 2;;
"Sentences") commonlist 3;;
"Save As") saveas;;
"Update") convertimg;;
* ) echo "none";;
esac
#echo $mode
}

init

