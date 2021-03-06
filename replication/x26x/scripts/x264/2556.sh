#!/bin/sh

numb='2557'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 0 --keyint 270 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.2,1.3,4.6,0.2,0.7,0.3,1,0,8,0,270,4,30,50,3,0,66,18,1,1000,1:1,hex,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"