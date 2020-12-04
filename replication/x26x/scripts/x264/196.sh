#!/bin/sh

numb='197'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 45 --keyint 240 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.2,1.4,1.0,0.3,0.9,0.3,3,2,10,45,240,2,29,20,3,3,69,38,2,1000,-2:-2,dia,show,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"