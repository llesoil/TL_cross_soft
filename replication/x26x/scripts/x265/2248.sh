#!/bin/sh

numb='2249'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.4,1.0,4.4,0.5,0.7,0.8,2,0,4,5,260,0,20,40,3,4,66,18,4,2000,-2:-2,hex,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"