#!/bin/sh

numb='1641'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 5.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 15 --keyint 220 --lookahead-threads 4 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.2,1.2,5.0,0.6,0.8,0.1,1,2,12,15,220,4,29,20,4,4,62,28,6,1000,1:1,dia,show,faster,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"