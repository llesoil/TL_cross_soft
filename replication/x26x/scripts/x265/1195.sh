#!/bin/sh

numb='1196'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 5 --keyint 220 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.6,1.3,3.2,0.3,0.7,0.5,3,1,12,5,220,1,25,20,5,0,68,48,4,2000,-2:-2,umh,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"