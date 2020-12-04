#!/bin/sh

numb='1947'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 5.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 15 --keyint 280 --lookahead-threads 0 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.0,1.1,5.0,0.4,0.7,0.9,1,2,14,15,280,0,23,10,5,3,60,18,4,1000,-2:-2,hex,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"