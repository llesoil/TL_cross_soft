#!/bin/sh

numb='773'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 2.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 0 --keyint 300 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.0,1.4,2.2,0.3,0.8,0.7,1,0,16,0,300,2,24,10,5,4,68,18,2,1000,-1:-1,umh,show,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"