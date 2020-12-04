#!/bin/sh

numb='2452'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.4 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 2 --crf 50 --keyint 290 --lookahead-threads 1 --min-keyint 29 --qp 50 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.5,1.2,1.4,0.2,0.7,0.3,2,1,2,50,290,1,29,50,5,3,67,18,2,1000,-2:-2,hex,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"