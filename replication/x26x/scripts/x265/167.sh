#!/bin/sh

numb='168'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 25 --keyint 300 --lookahead-threads 0 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.3,1.3,2.6,0.2,0.7,0.4,3,0,2,25,300,0,27,0,3,1,66,18,3,1000,1:1,dia,crop,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"