#!/bin/sh

numb='592'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 50 --keyint 220 --lookahead-threads 2 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.5,1.3,4.8,0.5,0.8,0.6,2,1,12,50,220,2,27,30,5,4,66,48,3,2000,-2:-2,dia,crop,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"