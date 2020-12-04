#!/bin/sh

numb='75'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 30 --keyint 250 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.4,1.0,3.0,0.4,0.7,0.2,1,1,2,30,250,2,24,10,4,4,66,28,4,1000,-1:-1,hex,show,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"