#!/bin/sh

numb='2245'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 20 --keyint 240 --lookahead-threads 0 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.5,1.4,1.3,4.6,0.4,0.9,0.7,0,0,2,20,240,0,24,0,4,1,65,28,2,2000,1:1,dia,crop,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"