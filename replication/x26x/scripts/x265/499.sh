#!/bin/sh

numb='500'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 25 --keyint 290 --lookahead-threads 0 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.6,1.0,4.8,0.3,0.8,0.4,0,1,2,25,290,0,24,50,4,0,60,48,6,2000,-2:-2,hex,crop,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"