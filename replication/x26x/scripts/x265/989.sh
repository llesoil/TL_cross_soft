#!/bin/sh

numb='990'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 5 --keyint 300 --lookahead-threads 0 --min-keyint 21 --qp 40 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.1,1.3,0.6,0.4,0.9,0.9,1,0,0,5,300,0,21,40,3,1,61,18,4,1000,1:1,hex,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"