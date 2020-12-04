#!/bin/sh

numb='1537'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 30 --keyint 250 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.1,1.4,1.0,0.6,0.9,0.3,3,1,12,30,250,4,23,20,3,0,66,28,5,1000,-2:-2,hex,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"