#!/bin/sh

numb='1826'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 25 --keyint 240 --lookahead-threads 2 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.6,1.2,4.8,0.5,0.8,0.7,0,2,6,25,240,2,27,40,5,0,66,18,3,2000,-1:-1,hex,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"