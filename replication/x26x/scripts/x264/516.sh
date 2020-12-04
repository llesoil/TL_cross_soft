#!/bin/sh

numb='517'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 20 --keyint 230 --lookahead-threads 2 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.4,1.2,2.8,0.4,0.6,0.3,3,0,2,20,230,2,29,30,4,0,66,18,4,1000,-2:-2,hex,show,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"