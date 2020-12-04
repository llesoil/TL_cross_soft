#!/bin/sh

numb='441'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 25 --keyint 220 --lookahead-threads 2 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.5,1.2,2.8,0.3,0.9,0.0,2,0,6,25,220,2,22,30,3,1,62,18,5,2000,-1:-1,hex,crop,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"