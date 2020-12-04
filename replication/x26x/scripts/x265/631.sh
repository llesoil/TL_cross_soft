#!/bin/sh

numb='632'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 1.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 15 --keyint 240 --lookahead-threads 0 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.5,1.0,1.6,0.5,0.7,0.7,3,2,8,15,240,0,23,0,3,2,63,38,2,2000,1:1,hex,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"