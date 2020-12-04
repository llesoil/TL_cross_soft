#!/bin/sh

numb='506'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 15 --keyint 220 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.0,1.2,0.2,0.4,0.9,0.1,2,1,2,15,220,1,30,30,4,1,67,48,5,2000,1:1,dia,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"