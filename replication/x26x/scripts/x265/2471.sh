#!/bin/sh

numb='2472'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 3 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.6,1.0,3.0,0.2,0.6,0.9,0,2,10,20,280,0,23,30,3,3,63,28,4,1000,1:1,dia,crop,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"