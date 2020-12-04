#!/bin/sh

numb='139'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 1.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 5 --keyint 220 --lookahead-threads 2 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.4,1.4,1.0,0.2,0.9,0.8,0,2,10,5,220,2,26,40,4,2,61,28,1,2000,-2:-2,umh,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"