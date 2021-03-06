#!/bin/sh

numb='1881'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 40 --keyint 220 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.5,1.1,3.0,0.3,0.6,0.7,0,2,2,40,220,0,22,0,3,0,65,38,3,2000,-2:-2,hex,show,veryslow,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"