#!/bin/sh

numb='1286'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 5 --keyint 220 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.2,1.0,2.2,0.5,0.6,0.3,2,2,10,5,220,0,25,20,4,1,66,18,3,1000,-1:-1,hex,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"