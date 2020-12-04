#!/bin/sh

numb='2296'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 5 --keyint 220 --lookahead-threads 0 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.4,1.0,3.0,0.3,0.9,0.0,3,1,0,5,220,0,27,30,4,2,67,18,5,1000,-2:-2,umh,crop,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"