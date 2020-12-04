#!/bin/sh

numb='697'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 25 --keyint 250 --lookahead-threads 1 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.3,1.2,4.6,0.6,0.7,0.6,3,0,0,25,250,1,26,40,4,1,68,18,4,1000,-1:-1,hex,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"