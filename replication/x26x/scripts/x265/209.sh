#!/bin/sh

numb='210'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 0.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 25 --keyint 290 --lookahead-threads 2 --min-keyint 22 --qp 40 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.2,1.3,0.4,0.4,0.7,0.8,2,0,6,25,290,2,22,40,5,1,64,38,2,1000,-1:-1,dia,crop,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"