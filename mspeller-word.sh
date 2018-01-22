#!/bin/bash
bgcolor="green"
bgalpha="100"
bcolor="blue"
c_width="1920"
c_height="1080"
csize=$c_width"x"$c_height
b_width="1920"
b_height="200"
bsize=$b_width"x"$b_height
strokecolor="black"
strokesize="2"
fcolor="white"
fontdic="FreeSans"
fontsize="100"
alphavalue="100"

function convertimg
{

echo "banner color " $bcolor
echo "font color "$fcolor
echo "canvas size "$c_height" "$c_width
echo "banner size "$bsize
index=1
imgfilname=$(echo $wordpath | awk -F/ '{print $NF}')
trimfname=${imgfilname%.*}

while read line
do
word_line=$(echo $line | cut -d',' -f1)
cword_line=$(sed -e 's/\b./\u\0/' <<< $word_line)
convert -background $bgcolor -size $csize xc:$bgcolor -alpha set -channel Alpha -evaluate set $bgalpha%  \( -size $bsize -background $bcolor xc:$bcolor -alpha set -channel Alpha -evaluate set $alphavalue% -gravity south -geometry +0+50 \) -composite \( -size $bsize -background none -fill $fcolor -pointsize $fontsize -font $fontdic -stroke $strokecolor -strokewidth $strokesize -geometry +0+100 caption:"${cword_line}" \) -composite  $savepath/$trimfname-$index.png
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
   --add-entry="Canvas Height(1080)" \
   --add-entry="Banner Width(1920)" \
   --add-entry="Banner Height(200)" 2>/dev/null)
c_width=$(echo $val | cut -d'|' -f1)
c_height=$(echo $val | cut -d'|' -f2)
b_width=$(echo $val | cut -d'|' -f3)
b_height=$(echo $val | cut -d'|' -f4)
csize=$c_width"x"$c_height
bsize=$b_width"x"$b_height
init
}

function openbanner
{
bannerpath=$(zenity --file-selection --file-filter="*.jpg" \
   --file-filter="*.jpg" \
   --file-filter="*.jpeg" \
   --file-filter="*.png" \
   --file-filter="*.tiff" 2>/dev/null)
bsize=$(identify -format "%wx%h" $bannerpath)
echo $bsize
#echo $bannerpath
init
}

function openword
{
wordpath=$(zenity --file-selection --file-filter="*.*" \
   --file-filter="*.txt" \
   --file-filter="*.odc" 2>/dev/null)
echo $wordpath
init
}

function colorpalatte
{
colorvalue=$(zenity --color-selection --show-palette 2>/dev/null)
if [[ $? -eq 0 ]];then
echo $1" color is not specified"
fi
}

function fontstrokecolor
{
colorpalatte "Stroke"
strokecolor=$colorvalue
init
}

function backcolor
{
colorpalatte "Font(100)"
bgcolor=$colorvalue
init
}

function fontcolor
{
colorpalatte "Font(100)"
fcolor=$colorvalue
init
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
if [[ $? -eq 0 ]];then
echo $1 " size is not specified"
fi
}

#font size entry
function fontproperty
{
entervalue "Font"
fontsize=$entryvalue
init
}

function fontstrokesize
{
entervalue "Stroke Size"
strokesize=$entryvalue
init
}

function fontlist
{
#fontdic=$(zenity --list --title="Font List" --height 500 --multiple  --column="flist" $(fc-list |  cut -d':' -f2))
fontdic=$(fc-list | cut -d':' -f2 | zenity --list --title="Font List" --height 500 --multiple  --column="flist" 2>/dev/null)
if [[ $? -eq 0 ]];then
echo "Font type is not specified"
fi
init

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

function init
{
mode=$(zenity --height 400 --list  --title="Main Configuration" --column="mode" "Frame Settings" "Open Word List" "Background Color" "Background Transparency" "Banner Color" "Banner Transparency"  "Font Color" "Font Size" "Font List" "Font Stroke Size" "Font Stroke Color"  "Save As" "Done" 2>/dev/null)
tmode=$(echo $mode | cut -d'|' -f1)
case $tmode in
"Frame Settings") configuration;;
"Open Word List") openword ;;
"Background Color") backcolor;;
"Background Transparency") backtransparency;;
"Banner Color") bannercolor;;
"Banner Transparency") bannertransparency;;
"Font Color" ) fontcolor;;
"Font Size") fontproperty;;
"Font List") fontlist;;
"Font Stroke Size") fontstrokesize;;
"Font Stroke Color") fontstrokecolor;;
"Save As") saveas;;
"Done") convertimg;;
* ) echo "none";;
esac
#echo $mode
}

init

