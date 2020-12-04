#!/bin/sh

numb='57'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 35 --keyint 250 --lookahead-threads 2 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.3,4.8,0.3,0.9,0.0,3,1,4,35,250,2,30,20,5,2,65,28,3,1000,-1:-1,hex,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"