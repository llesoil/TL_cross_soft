#!/bin/sh

numb='458'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 1.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 30 --keyint 220 --lookahead-threads 4 --min-keyint 27 --qp 20 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.3,1.2,1.4,0.2,0.7,0.2,0,2,8,30,220,4,27,20,4,3,63,48,3,1000,-2:-2,dia,show,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"