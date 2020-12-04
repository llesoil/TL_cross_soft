#!/bin/sh

numb='2129'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 2.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 5 --keyint 290 --lookahead-threads 3 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.5,1.1,2.8,0.3,0.8,0.0,1,2,16,5,290,3,26,40,3,2,63,28,6,1000,-2:-2,hex,crop,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"