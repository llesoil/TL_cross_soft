#!/bin/sh

numb='1522'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 15 --keyint 230 --lookahead-threads 2 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.5,1.3,0.8,0.6,0.7,0.5,0,2,10,15,230,2,21,40,4,1,60,18,5,2000,1:1,hex,crop,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"