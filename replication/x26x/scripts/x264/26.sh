#!/bin/sh

numb='27'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 10 --keyint 220 --lookahead-threads 3 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.5,1.3,1.1,0.4,0.3,0.7,0.8,0,0,12,10,220,3,27,0,4,4,64,18,3,1000,-1:-1,hex,show,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"