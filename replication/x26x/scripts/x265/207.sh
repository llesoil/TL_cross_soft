#!/bin/sh

numb='208'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 1.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 10 --keyint 250 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.4,1.1,1.2,0.4,0.9,0.1,2,2,12,10,250,0,30,10,4,2,63,28,4,2000,-2:-2,hex,show,slow,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"