#!/bin/sh

numb='830'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 40 --keyint 230 --lookahead-threads 3 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.6,1.2,4.8,0.5,0.6,0.9,1,1,6,40,230,3,30,30,5,2,68,48,5,2000,-1:-1,dia,show,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"