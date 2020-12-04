#!/bin/sh

numb='1636'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 35 --keyint 250 --lookahead-threads 4 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.5,1.1,1.4,3.4,0.4,0.6,0.3,0,0,4,35,250,4,28,20,4,2,67,38,6,1000,-2:-2,hex,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"