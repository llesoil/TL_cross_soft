#!/bin/sh

numb='741'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 10 --keyint 200 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.1,1.1,1.6,0.3,0.6,0.3,3,1,10,10,200,1,30,50,3,0,60,28,5,1000,1:1,hex,crop,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"