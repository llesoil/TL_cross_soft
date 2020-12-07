#!/bin/sh

numb='466'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 21 --qp 50 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.0,1.3,1.4,3.2,0.6,0.8,0.4,0,2,14,20,280,0,21,50,5,2,65,48,4,1000,1:1,hex,show,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"