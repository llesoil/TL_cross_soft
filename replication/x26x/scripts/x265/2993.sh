#!/bin/sh

numb='2994'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 45 --keyint 250 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.4,1.2,1.0,0.4,0.7,0.3,0,2,6,45,250,2,30,10,5,1,68,48,5,2000,-2:-2,umh,show,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"