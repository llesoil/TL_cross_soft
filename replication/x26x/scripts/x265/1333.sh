#!/bin/sh

numb='1334'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 25 --keyint 280 --lookahead-threads 1 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.4,1.4,2.2,0.5,0.6,0.2,3,1,10,25,280,1,25,30,4,2,69,38,5,2000,1:1,hex,crop,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"