#!/bin/sh

numb='954'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 30 --keyint 300 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.1,1.3,3.4,0.3,0.8,0.6,3,2,4,30,300,3,30,40,3,3,69,28,3,1000,-1:-1,hex,crop,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"