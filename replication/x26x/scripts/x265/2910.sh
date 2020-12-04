#!/bin/sh

numb='2911'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 20 --keyint 220 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.2,1.1,0.6,0.2,0.7,0.8,1,1,4,20,220,2,28,50,5,2,63,48,3,2000,-2:-2,hex,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"