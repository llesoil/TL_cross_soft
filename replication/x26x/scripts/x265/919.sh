#!/bin/sh

numb='920'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --intra-refresh --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 10 --keyint 260 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,None,--slow-firstpass,--weightb,0.0,1.4,1.2,1.4,0.6,0.8,0.6,0,2,6,10,260,2,29,20,4,4,60,38,1,2000,1:1,dia,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"