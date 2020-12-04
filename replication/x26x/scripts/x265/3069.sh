#!/bin/sh

numb='3070'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 5 --keyint 290 --lookahead-threads 4 --min-keyint 23 --qp 0 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.0,1.6,1.1,2.0,0.6,0.6,0.4,0,1,14,5,290,4,23,0,5,4,67,38,4,1000,1:1,umh,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"